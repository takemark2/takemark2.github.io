***Settings***
Library    SeleniumLibrary
Library    DataDriver    data/sites_data.csv    encoding=UTF-8    # CSVファイルのパスを相対指定
Resource   common_keywords.robot

Test Setup        Open Browser For Current Test    ${Browser_To_Use}  # CSVの Browser_To_Use 列の値が渡される
Test Teardown     Close All Browsers
Test Template     Process Single Site From Data  # CSVの各行がこのキーワードで処理される

***Variables***
# ${BROWSER} は common_keywords.robot で定義・使用されます。
# robot.py から変数を渡す場合は、そちらが優先されます。
# 例: robot.run(..., variable=['BROWSER:firefox'])

***Test Cases***
# このセクションはDataDriverによって動的に生成されます。
# CSVファイルの最初の列（Site_Name）がテストケース名になります。
# 例: Test ${Site_Name}

***Keywords***
Process Single Site From Data
    [Arguments]    ${Site_Name}    ${URL}    ${Browser_To_Use}    ${Username}=${EMPTY}    ${Password}=${EMPTY}    ${Username_Locator}=${EMPTY}    ${Password_Locator}=${EMPTY}    ${Login_Button_Locator}=${EMPTY}    ${Login_Success_Element_Locator}=${EMPTY}    ${Expected_Title_Contains}=${EMPTY}    ${Post_Login_Check_Element}=${EMPTY}
    # ${Browser_To_Use} は Test Setup で使用されるため、このキーワード内では直接ブラウザ起動には使いませんが、DataDriverが値を渡すために引数に含める必要があります。
    Log To Console    \n--- Processing Site: ${Site_Name} (Browser hint from CSV: ${Browser_To_Use}) ---
    Log    URL: ${URL}, Username: ${Username}, Browser specified in CSV: ${Browser_To_Use}

    Go To    ${URL}
    Set Selenium Speed    0.1 seconds  # 動作確認用。高速化する場合はコメントアウトまたは削除

    IF    '${Username}' != '${EMPTY}' and '${Password}' != '${EMPTY}' and '${Username_Locator}' != '${EMPTY}'
        Login To Site    ${Username}    ${Password}    ${Username_Locator}    ${Password_Locator}    ${Login_Button_Locator}    ${Login_Success_Element_Locator}
    END

    # ログイン後またはページ遷移後の基本的なチェック
    IF    '${Expected_Title_Contains}' != '${EMPTY}'
        Title Should Contain    ${Expected_Title_Contains}    timeout=15s
    END

    IF    '${Post_Login_Check_Element}' != '${EMPTY}'
        Wait Until Page Contains Element    ${Post_Login_Check_Element}    timeout=15s
        Log    Post-login check element '${Post_Login_Check_Element}' found.
    END

    # ここにサイトごとの追加の検証ステップを記述することも可能
    # (例: 特定の要素の存在確認、テキスト内容の検証など)
    Log To Console    --- Finished Processing: ${Site_Name} ---