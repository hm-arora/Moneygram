import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:moneygram/account/model/account.dart';
import 'package:moneygram/account/repository/account_repository.dart';
import 'package:moneygram/backup/google_auth_client.dart';
import 'package:moneygram/backup/google_drive_constants.dart';
import 'package:moneygram/category/model/category.dart';
import 'package:moneygram/category/repository/category_repository.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/transactions/models/transaction.dart';
import 'package:moneygram/transactions/repository/transaction_repository.dart';
import 'package:moneygram/utils/validation_utils.dart';

class GoogleDriveService {
  static GoogleSignInAccount? _account;

  static Future<GoogleSignInAccount?> _login() {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive.DriveApi.driveAppdataScope]);
    return googleSignIn.signIn();
  }

  static Future<GoogleSignInAccount?> _getAccount() async {
    if (_account != null) {
      return _account;
    }
    _account = await _login();
    return _account;
  }

  static Future<drive.DriveApi> _getDriveAPI() async {
    final account = await _getAccount();
    print("User account: $account");
    if (account == null) {
      Exception("Account not signin");
    }
    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);
    return driveApi;
  }

  static Future<void> upload() async {
    final driveApi = await _getDriveAPI();

    await _backupAccounts(driveApi: driveApi);
    await _backupCategories(driveApi: driveApi);
    await _backupTransactions(driveApi: driveApi);
  }

  static Future<void> _backupAccounts(
      {required drive.DriveApi driveApi}) async {
    var accounts = await _getPendingAccounts();
    if (accounts.isEmpty) {
      return;
    }
    final filename =
        '${GoogleDriveConstants.ACCOUNTS_FOLDER}/${DateTime.now().millisecondsSinceEpoch}.txt';
    var accountContent = "";
    for (var account in accounts) {
      accountContent += json.encode(account.toJson()) + "\n";
    }
    await _uploadFile(
        driveApi: driveApi, filename: filename, textContent: accountContent);
    for (var t in accounts) {
      t.isSync = true;
      t.save();
    }
  }

  static Future<void> _backupCategories(
      {required drive.DriveApi driveApi}) async {
    var categories = await _getPendingCategories();
    if (categories.isEmpty) {
      return;
    }
    final filename =
        '${GoogleDriveConstants.CATEGORIES_FOLDER}/${DateTime.now().millisecondsSinceEpoch}.txt';
    var categoryContent = "";
    for (var category in categories) {
      categoryContent += json.encode(category.toJson()) + "\n";
    }
    await _uploadFile(
        driveApi: driveApi, filename: filename, textContent: categoryContent);
    for (var t in categories) {
      t.isSync = true;
      t.save();
    }
  }

  static Future<void> _backupTransactions(
      {required drive.DriveApi driveApi}) async {
    var transactions = await _getPendingTransactions();
    if (transactions.isEmpty) {
      return;
    }
    final filename =
        '${GoogleDriveConstants.TRANSACTIONS_FOLDER}/${DateTime.now().millisecondsSinceEpoch}.txt';
    var transactionContent = "";
    for (var transaction in transactions) {
      transactionContent += json.encode(transaction.toJson()) + "\n";
    }
    await _uploadFile(
        driveApi: driveApi,
        filename: filename,
        textContent: transactionContent);
    for (var t in transactions) {
      t.isSync = true;
      t.save();
    }
  }

  static Future<void> _uploadFile(
      {required String filename,
      required String textContent,
      required drive.DriveApi driveApi}) async {
    var content = utf8.encode(textContent);
    var media = drive.Media(Stream.value(content), content.length);
    var driveFile = drive.File(name: filename, parents: ['appDataFolder']);
    var resumableUploadOptions = drive.ResumableUploadOptions();
    await driveApi.files.create(driveFile,
        uploadMedia: media, uploadOptions: resumableUploadOptions);
    print("------------- \n uploaded: $filename \n");
    print("content: $textContent");
  }

  static Future<void> readFiles() async {
    print("reading file\n");
    final driveApi = await _getDriveAPI();
    var fileList = await driveApi.files
        .list(spaces: 'appDataFolder', orderBy: 'modifiedTime asc');
    var files = fileList.files ?? [];
    for (var file in files) {
      print(file.name);
      await getFileContent(file.name!, file.id!);
      // await deleteFile(file.name!, file.id!);
      // print(file.)
    }
  }

  static Future<void> getFileContent(String filename, String fileId) async {
    final driveApi = await _getDriveAPI();
    var response = await driveApi.files.get(fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
        $fields: 'items/quotaBytesUsed');
    if (response is! drive.Media) throw Exception("invalid response");
    var decodeString = await utf8.decodeStream(response.stream);
    print('\n --------filename: $filename');
    // print("\n $decodeString");
    var folderName = filename.split('/')[0];
    if (folderName == GoogleDriveConstants.TRANSACTIONS_FOLDER) {
      _readTransactions(decodeString);
    } else if (folderName == GoogleDriveConstants.ACCOUNTS_FOLDER) {
      _readAccounts(decodeString);
    } else if (folderName == GoogleDriveConstants.CATEGORIES_FOLDER) {
      _readCategories(decodeString);
    }
  }

  static void _readTransactions(String content) {
    List<String> list = content.split("\n");
    TransactionRepository repository = locator.get();
    for (var body in list) {
      if (ValidationUtils.isValidString(body)) {
        var transaction = Transaction.fromJson(json.decode(body))
          ..isSync = true;
        repository.updateTransaction(transaction, forceOverride: true);
      }
    }
  }

  static void _readAccounts(String content) {
    List<String> list = content.split("\n");
    AccountRepository repository = locator.get();
    for (var body in list) {
      if (ValidationUtils.isValidString(body)) {
        var account = Account.fromJson(json.decode(body))..isSync = true;
        repository.updateAccount(account);
      }
    }
  }

  static void _readCategories(String content) {
    List<String> list = content.split("\n");
    CategoryRepository repository = locator.get();
    for (var body in list) {
      if (ValidationUtils.isValidString(body)) {
        var category = Category.fromJson(json.decode(body))..isSync = true;
        repository.updateCategory(category);
      }
    }
  }

  static Future<void> deleteFile(String name, String fileId) async {
    final driveApi = await _getDriveAPI();
    await driveApi.files.delete(fileId);
    print("\n ${name} deleted -----------------\n");
  }

  static Future<List<Transaction>> _getPendingTransactions() async {
    List<Transaction> list = [];
    TransactionRepository transactionRepository = locator.get();
    var transactions = await transactionRepository.getAllTransactions(true);
    for (var transaction in transactions) {
      // if it is not synced then only add it to the list for syncing
      if (!transaction.isSync) {
        list.add(transaction);
      }
    }
    return list;
  }

  static Future<List<Category>> _getPendingCategories() async {
    List<Category> list = [];
    CategoryRepository categoryRepository = locator.get();
    var categories = await categoryRepository.categories(isSort: false);
    for (var category in categories) {
      // if it is not synced then only add it to the list for syncing
      if (!category.isSync) {
        list.add(category);
      }
    }
    return list;
  }

  static Future<List<Account>> _getPendingAccounts() async {
    List<Account> list = [];
    AccountRepository accountRepository = locator.get();
    var accounts = await accountRepository.accounts(isSort: false);
    for (var account in accounts) {
      // if it is not synced then only add it to the list for syncing
      if (!account.isSync) {
        list.add(account);
      }
    }
    return list;
  }

  static Future<void> deleteFiles() async {
    print("deleting file\n");
    final driveApi = await _getDriveAPI();
    var fileList = await driveApi.files.list(spaces: 'appDataFolder');
    var files = fileList.files ?? [];
    for (var file in files) {
      print(file.name);
      await deleteFile(file.name!, file.id!);
      // print(file.)
    }
  }
}
