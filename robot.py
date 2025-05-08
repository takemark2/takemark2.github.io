import robot
import sys
import os

# 実行形式化された環境でのテストファイルのパスを考慮
# '--add-data "your_test.robot;." とした場合、実行形式からのパスは 'your_test.robot'
# --onedir で出力した場合、実行形式と同じディレクトリに同梱される想定
# 実行形式と同じディレクトリにテストファイルがあるという簡単な前提とします。
robot_test_file = 'your_test.robot' # テストファイル名に合わせて変更

# WebDriverのパス設定（重要！）
# APIを利用する場合も、SeleniumLibraryがWebDriverを見つけられるように設定が必要です。
# 実行形式と同じディレクトリにWebDriverが同梱されている場合、そのディレクトリをPATHに追加します。
# PyInstallerでWebDriver実行ファイルを同梱した場合、そのディレクトリをPATHに追加します。

# 対応するWebDriverのファイル名リスト (Windowsを主に想定、Linux/macOSも考慮)
webdriver_filenames = [
    'chromedriver.exe', 'chromedriver',  # Chrome
    'msedgedriver.exe', 'msedgedriver',  # Edge
    'IEDriverServer.exe'                 # Internet Explorer (Windowsのみ)
]

current_dir = os.path.dirname(sys.argv[0]) # 実行形式のディレクトリ
webdriver_found_in_script_dir = False
found_driver_for_path = None

# いずれかのWebDriverファイルが実行形式と同じディレクトリにあるか確認
for driver_name in webdriver_filenames:
    potential_driver_path = os.path.join(current_dir, driver_name)
    if os.path.exists(potential_driver_path):
        webdriver_found_in_script_dir = True
        found_driver_for_path = driver_name # PATH追加メッセージ用
        break # 1つ見つかれば、そのディレクトリをPATHに追加すればOK

if webdriver_found_in_script_dir:
    os.environ['PATH'] += os.pathsep + current_dir
    print(f"Found WebDriver ('{found_driver_for_path}') in script directory. Added '{current_dir}' to PATH.")
else:
     print(f"No common WebDrivers (Chrome, Edge, IE) found in '{current_dir}'. Ensure WebDriver is in system PATH or bundled with the script/executable.")
     # WebDriverが見つからない場合、Seleniumテストは失敗します。
     # ここでエラーとして処理を終了させることも可能です。
     # sys.exit(1) # WebDriverが見つからない場合はエラー終了


print(f"Attempting to run Robot Framework tests using API from: {robot_test_file}")

try:
    # Robot FrameworkのAPIを使ってテストを実行
    # robot.run() 関数の引数は、コマンドラインオプションに似ています。
    # 引数は文字列のリストとして渡します。
    # --outputdir: ログやレポートを保存するディレクトリを指定
    # --loglevel: ログレベルを指定 (INFO, DEBUGなど)
    # 引数としてテストファイルのパスを渡す
    result_code = robot.run(
        robot_test_file,
        outputdir='robot_logs_api', # 出力ディレクトリ名
        loglevel='INFO',          # ログレベル
        # その他、Robot Frameworkのコマンドラインオプションに対応する引数を追加可能
        # เช่น, variable=['BROWSER:chrome'] # 変数を渡す例
    )

    print("\nRobot Framework Test Execution Completed.")

    # robot.run() は実行結果コード（0:成功, 非ゼロ:失敗）を返します
    if result_code == 0:
        print("Robot Framework tests passed successfully.")
    else:
        print(f"Robot Framework tests failed with return code {result_code}.")
        # テスト失敗を示すために、このスクリプトも非ゼロの終了コードで終了する
        sys.exit(result_code)

except Exception as e:
    print(f"An unexpected error occurred during Robot Framework API execution: {e}")
    sys.exit(1) # エラー終了