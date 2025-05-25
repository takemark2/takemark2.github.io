graph TD
    subgraph Zscaler ZIdentity
        U("👤 ユーザー")
        UG("👨‍👩‍👧‍👦 ユーザーグループ")
        R("🛡️ ロール")
    end

    subgraph Zscaler Services
        ZIA("☁️ ZIA (Internet Access)")
        ZPA("🏢 ZPA (Private Access)")
        ZDX("💻 ZDX (Digital Experience)")
    end

    subgraph Permissions
        P_ZIA("🔑 ZIA権限\n(ポリシー管理、ログ閲覧など)")
        P_ZPA("🔑 ZPA権限\n(アプリセグメント管理、アクセスポリシーなど)")
        P_ZDX("🔑 ZDX権限\n(ダッシュボード閲覧、プローブ設定など)")
    end

    %% 関係性
    U -- 所属 --> UG
    UG -- "ロール割り当て (推奨)" --> R
    U -- "ロール割り当て (個別も可)" --> R

    R -- "定義する" --> P_ZIA
    R -- "定義する" --> P_ZPA
    R -- "定義する" --> P_ZDX

    P_ZIA -- "アクセス制御" --> ZIA
    P_ZPA -- "アクセス制御" --> ZPA
    P_ZDX -- "アクセス制御" --> ZDX

    classDef zscaler fill:#f9f,stroke:#333,stroke-width:2px;
    class U,UG,R zscaler;

    classDef services fill:#ccf,stroke:#333,stroke-width:2px;
    class ZIA,ZPA,ZDX services;

    classDef permissions fill:#cfc,stroke:#333,stroke-width:2px;
    class P_ZIA,P_ZPA,P_ZDX permissions;