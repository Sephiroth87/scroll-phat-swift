//
//  ScrollpHAT.swift
//  sroll-phat-swift
//
//  Created by Fabio Ritrovato on 14/01/2016.
//  Copyright (c) 2016 orange in a day. All rights reserved.
//

public class ScrollpHAT {
    
    static private let i2cAddress: Int32 = 0x60
    static private let cmdSetMode: UInt8 = 0x00
    static private let cmdSetState: UInt8 = 0x01
    static private let cmdSetBrightness: UInt8 = 0x19
    static private let mode5x11: UInt8 = 0x03
    
    private let bus: SMBus
    private var buffer = [UInt8](count: 11, repeatedValue: UInt8(0x00))
    
    public init() throws {
        try bus = SMBus(busNumber: 1)
        try bus.writeI2CBlockData(ScrollpHAT.i2cAddress, command: ScrollpHAT.cmdSetMode, values: [ScrollpHAT.mode5x11])
        
    }
    
    public func update() throws {
        var window = buffer
        window.append(0xFF)
        try bus.writeI2CBlockData(ScrollpHAT.i2cAddress, command: ScrollpHAT.cmdSetState, values: window)
    }
    
    public func setBrightness(brightness: Int) throws {
        try bus.writeI2CBlockData(ScrollpHAT.i2cAddress, command: ScrollpHAT.cmdSetBrightness, values: [UInt8(brightness)])
    }
    
    public func setPixel(x x: Int, y: Int, value: Bool) {
        guard x >= 0 && x < 11 && y >= 0 && y < 5 else { return }
        if value {
            buffer[x] |= UInt8(1 << y)
        } else {
            buffer[x] &= ~UInt8(1 << y)
        }
    }

}
