// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// Specifies the value of an Internet Password Keychain Item's Internet Protocol.
/// Maps to possible values for use with the `kSecAttrProtocol` key.
///
/// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1678890)
public enum KeychainInternetProtocol: RawRepresentable {
    /// AFP over TCP.
    case afp
    /// AFP over AppleTalk.
    case appleTalk
    /// DAAP protocol.
    case daap
    /// Remote Apple Events.
    case eppc
    /// FTP protocol.
    case ftp
    /// A client side FTP account.
    case ftpAccount
    /// FTP proxy.
    case ftpProxy
    /// FTP over TLS/SSL.
    case ftps
    /// HTTP protocol.
    case http
    /// HTTP proxy.
    case httpProxy
    /// HTTP over TLS/SSL.
    case https
    /// HTTPS proxy.
    case httpsProxy
    /// IMAP protocol.
    case imap
    /// IMAP over TLS/SSL.
    case imaps
    /// IPP protocol.
    case ipp
    /// IRC protocol.
    case irc
    /// IRC over TLS/SSL.
    case ircs
    /// LDAP protocol.
    case ldap
    /// LDAP over TLS/SSL.
    case ldaps
    /// NNTP protocol.
    case nntp
    /// NNTP over TLS/SSL.
    case nntps
    /// POP3 protocol.
    case pop3
    /// POP3 over TLS/SSL.
    case pop3s
    /// RTSP protocol.
    case rtsp
    /// RTSP proxy.
    case rtspProxy
    /// SMB protocol.
    case smb
    /// SMTP protocol.
    case smtp
    /// SOCKS protocol.
    case socks
    /// SSH protocol.
    case ssh
    /// Telnet protocol.
    case telnet
    /// Telnet over TLS/SSL.
    case telnetS
    
    public var rawValue: String {
        switch self {
        case .afp:
            return String(kSecAttrProtocolAFP)
        case .appleTalk:
            return String(kSecAttrProtocolAppleTalk)
        case .daap:
            return String(kSecAttrProtocolDAAP)
        case .eppc:
            return String(kSecAttrProtocolEPPC)
        case .ftp:
            return String(kSecAttrProtocolFTP)
        case .ftpAccount:
            return String(kSecAttrProtocolFTPAccount)
        case .ftpProxy:
            return String(kSecAttrProtocolFTPProxy)
        case .ftps:
            return String(kSecAttrProtocolFTPS)
        case .http:
            return String(kSecAttrProtocolHTTP)
        case .httpProxy:
            return String(kSecAttrProtocolHTTPProxy)
        case .https:
            return String(kSecAttrProtocolHTTPS)
        case .httpsProxy:
            return String(kSecAttrProtocolHTTPSProxy)
        case .imap:
            return String(kSecAttrProtocolIMAP)
        case .imaps:
            return String(kSecAttrProtocolIMAPS)
        case .ipp:
            return String(kSecAttrProtocolIPP)
        case .irc:
            return String(kSecAttrProtocolIRC)
        case .ircs:
            return String(kSecAttrProtocolIRCS)
        case .ldap:
            return String(kSecAttrProtocolLDAP)
        case .ldaps:
            return String(kSecAttrProtocolLDAPS)
        case .nntp:
            return String(kSecAttrProtocolNNTP)
        case .nntps:
            return String(kSecAttrProtocolNNTPS)
        case .pop3:
            return String(kSecAttrProtocolPOP3)
        case .pop3s:
            return String(kSecAttrProtocolPOP3S)
        case .rtsp:
            return String(kSecAttrProtocolRTSP)
        case .rtspProxy:
            return String(kSecAttrProtocolRTSPProxy)
        case .smb:
            return String(kSecAttrProtocolSMB)
        case .smtp:
            return String(kSecAttrProtocolSMTP)
        case .socks:
            return String(kSecAttrProtocolSOCKS)
        case .ssh:
            return String(kSecAttrProtocolSSH)
        case .telnet:
            return String(kSecAttrProtocolTelnet)
        case .telnetS:
            return String(kSecAttrProtocolTelnetS)
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrProtocolAFP):
            self = .afp
        case String(kSecAttrProtocolAppleTalk):
            self = .appleTalk
        case String(kSecAttrProtocolDAAP):
            self = .daap
        case String(kSecAttrProtocolEPPC):
            self = .eppc
        case String(kSecAttrProtocolFTP):
            self = .ftp
        case String(kSecAttrProtocolFTPAccount):
            self = .ftpAccount
        case String(kSecAttrProtocolFTPProxy):
            self = .ftpProxy
        case String(kSecAttrProtocolFTPS):
            self = .ftps
        case String(kSecAttrProtocolHTTP):
            self = .http
        case String(kSecAttrProtocolHTTPProxy):
            self = .httpProxy
        case String(kSecAttrProtocolHTTPS):
            self = .https
        case String(kSecAttrProtocolHTTPSProxy):
            self = .httpsProxy
        case String(kSecAttrProtocolIMAP):
            self = .imap
        case String(kSecAttrProtocolIMAPS):
            self = .imaps
        case String(kSecAttrProtocolIPP):
            self = .ipp
        case String(kSecAttrProtocolIRC):
            self = .irc
        case String(kSecAttrProtocolIRCS):
            self = .ircs
        case String(kSecAttrProtocolLDAP):
            self = .ldap
        case String(kSecAttrProtocolLDAPS):
            self = .ldaps
        case String(kSecAttrProtocolNNTP):
            self = .nntp
        case String(kSecAttrProtocolNNTPS):
            self = .nntps
        case String(kSecAttrProtocolPOP3):
            self = .pop3
        case String(kSecAttrProtocolPOP3S):
            self = .pop3s
        case String(kSecAttrProtocolRTSP):
            self = .rtsp
        case String(kSecAttrProtocolRTSPProxy):
            self = .rtspProxy
        case String(kSecAttrProtocolSMB):
            self = .smb
        case String(kSecAttrProtocolSMTP):
            self = .smtp
        case String(kSecAttrProtocolSOCKS):
            self = .socks
        case String(kSecAttrProtocolSSH):
            self = .ssh
        case String(kSecAttrProtocolTelnet):
            self = .telnet
        case String(kSecAttrProtocolTelnetS):
            self = .telnetS
        default:
            return nil
        }
    }
}
