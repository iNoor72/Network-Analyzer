//
//  PortsManager.swift
//  NSP
//
//  Created by Noor Walid on 24/05/2022.
//  Copyright © 2022 Sirak Berhane. All rights reserved.
//

import Foundation

class PortsManager {
    static let shared = PortsManager()
    private init() {}
    
    func checkTcpPortForListen(port: in_port_t) -> (Bool) {

      let socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0)
      if socketFileDescriptor == -1 {
        print("SocketCreationFailed, \(descriptionOfLastError())")
        return false
      }

      var addr = sockaddr_in()
      let sizeOfSockkAddr = MemoryLayout<sockaddr_in>.size
      addr.sin_len = __uint8_t(sizeOfSockkAddr)
      addr.sin_family = sa_family_t(AF_INET)
      addr.sin_port = Int(OSHostByteOrder()) == OSLittleEndian ? _OSSwapInt16(port) : port
      addr.sin_addr = in_addr(s_addr: inet_addr("0.0.0.0"))
      addr.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)
      var bind_addr = sockaddr()
      memcpy(&bind_addr, &addr, Int(sizeOfSockkAddr))

      if Darwin.bind(socketFileDescriptor, &bind_addr, socklen_t(sizeOfSockkAddr)) == -1 {
        let details = descriptionOfLastError()
        release(socket: socketFileDescriptor)
        print("\(port), BindFailed, \(details)")
        return false
      }
      if listen(socketFileDescriptor, SOMAXCONN ) == -1 {
        let details = descriptionOfLastError()
        release(socket: socketFileDescriptor)
        print("\(port), BindFailed, \(details)")
        return false
      }
      release(socket: socketFileDescriptor)
      print("\(port) is free for use")
      return true
    }
    
    private func release(socket: Int32) {
      Darwin.shutdown(socket, SHUT_RDWR)
      close(socket)
    }

    private func descriptionOfLastError() -> String {
      return String.init(cString: (UnsafePointer(strerror(errno))))
    }
}