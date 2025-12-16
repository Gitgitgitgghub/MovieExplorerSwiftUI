//
//  AuthKeychainStore.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/16.
//

import Foundation
import Security

/// 以 Keychain 保存授權憑證（登入 session / 訪客 session）
struct AuthKeychainStore: AuthCredentialStore {

    /// Keychain service 識別值（用於隔離同一 App 的不同資料群組）
    private let service: String

    /// 建立 Keychain store（預設使用 App 的 bundle identifier）
    init(service: String = Bundle.main.bundleIdentifier ?? "MovieExplorerSwiftUI") {
        self.service = service
    }

    func readSessionID() -> String? {
        readString(account: Key.sessionID)
    }

    func readGuestSession() -> GuestSessionCredential? {
        guard let sessionID = readString(account: Key.guestSessionID) else { return nil }
        let expiresAt = readDate(account: Key.guestExpiresAt)
        return GuestSessionCredential(sessionID: sessionID, expiresAt: expiresAt)
    }

    func writeSessionID(_ sessionID: String) {
        writeString(sessionID, account: Key.sessionID)
    }

    func writeGuestSession(sessionID: String, expiresAt: Date?) {
        writeString(sessionID, account: Key.guestSessionID)
        if let expiresAt {
            writeDate(expiresAt, account: Key.guestExpiresAt)
        } else {
            delete(account: Key.guestExpiresAt)
        }
    }

    func clearAll() {
        delete(account: Key.sessionID)
        clearGuestSession()
    }

    func clearGuestSession() {
        delete(account: Key.guestSessionID)
        delete(account: Key.guestExpiresAt)
    }
}

private extension AuthKeychainStore {

    enum Key {
        /// 登入用 v3 session id（session_id）
        static let sessionID: String = "tmdb.session_id"
        /// 訪客 session id（guest_session_id）
        static let guestSessionID: String = "tmdb.guest_session_id"
        /// 訪客到期時間（以 timeIntervalSince1970 存字串）
        static let guestExpiresAt: String = "tmdb.guest_expires_at"
    }

    var baseQuery: [CFString: Any] {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
    }

    func readString(account: String) -> String? {
        guard let data = readData(account: account) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func writeString(_ value: String, account: String) {
        guard let data = value.data(using: .utf8) else { return }
        writeData(data, account: account)
    }

    func readDate(account: String) -> Date? {
        guard let raw = readString(account: account),
              let timeInterval = TimeInterval(raw) else {
            return nil
        }
        return Date(timeIntervalSince1970: timeInterval)
    }

    func writeDate(_ value: Date, account: String) {
        writeString(String(value.timeIntervalSince1970), account: account)
    }

    func readData(account: String) -> Data? {
        var query = baseQuery
        query[kSecAttrAccount] = account
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        return item as? Data
    }

    func writeData(_ data: Data, account: String) {
        var query = baseQuery
        query[kSecAttrAccount] = account
        query[kSecValueData] = data

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            let attributesToUpdate: [CFString: Any] = [kSecValueData: data]
            let updateQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ]
            SecItemUpdate(updateQuery as CFDictionary, attributesToUpdate as CFDictionary)
        }
    }

    func delete(account: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}

