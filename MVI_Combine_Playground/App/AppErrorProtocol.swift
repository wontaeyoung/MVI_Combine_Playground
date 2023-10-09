//
//  AppErrorProtocol.swift
//  MVI_Combine_Playground
//
//  Created by 원태영 on 10/9/23.
//

protocol AppErrorProtocol: Error {
    var errorDescription: String { get }
}

