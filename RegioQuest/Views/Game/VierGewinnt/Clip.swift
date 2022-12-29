//
//  Clip.swift
//  RegioQuest
//
//  Created by Orhan Salman on 21.12.22.
//

import Foundation
import UIKit

// Diese Klasse repräsentiert das Vier-Gewinnt-Spiel
class VierGewinnt {
  // Die Größe des Spiels, z.B. 7x6 für ein 7 Spalten und 6 Reihen großes Spiel
  let size: (columns: Int, rows: Int)
  
  // Das Array, das den aktuellen Zustand des Spiels speichert.
  // 0 bedeutet, dass die Stelle leer ist.
  // 1 bedeutet, dass Spieler 1 einen Stein platziert hat.
  // 2 bedeutet, dass Spieler 2 einen Stein platziert hat.
  var board: [[Int]]
  
  // Der aktuelle Spieler (1 oder 2)
  var currentPlayer: Int
  
  // Initialisiert das Vier-Gewinnt-Spiel
  init(columns: Int, rows: Int) {
    self.size = (columns, rows)
    self.board = Array(repeating: Array(repeating: 0, count: rows), count: columns)
    self.currentPlayer = 1
  }
  
  // Versucht, den Stein des aktuellen Spielers in die angegebene Spalte zu platzieren.
  // Gibt true zurück, wenn der Stein platziert wurde, andernfalls false.
  func placeStone(inColumn column: Int) -> Bool {
    // Überprüfe, ob die Spalte voll ist oder ob sie außerhalb des gültigen Bereichs liegt
    if column < 0 || column >= size.columns || board[column][0] != 0 {
      return false
    }
    
    // Suche die nächste freie Stelle in der Spalte
    for row in 0..<size.rows {
      if board[column][row] == 0 {
        // Platziere den Stein des aktuellen Spielers an dieser Stelle
        board[column][row] = currentPlayer
        
        // Wechsle den aktuellen Spieler
        currentPlayer = currentPlayer == 1 ? 2 : 1
        
        return true
      }
    }
    
    return false
  }
  
  // Überprüft, ob das Spiel beendet ist (d.h. ob ein Spieler gewonnen hat oder das Brett voll ist).
  // Gibt 0 zurück, wenn das Spiel noch nicht beendet ist.
  // Gibt 1 oder 2 zurück, wenn ein Spieler gewonnen hat.
  // Gibt -1 zurück, wenn das Spiel unentschieden endet.
  func checkGameOver() -> Int {
      // Überprüfe, ob ein Spieler gewonnen hat
      for column in 0..<size.columns {
        for row in 0..<size.rows {
          let stone = board[column][row]
          
          // Überprüfe, ob der Stein Teil einer horizontalen, vertikalen oder diagonalen Gewinnkombination ist
            if stone != 0 &&
                (checkLine(x1: column, y1: row, x2: column + 3, y2: row, directionX: 1, 0, stone) ||
                 checkLine(x1: column, y1: row, x2: column, y2: row + 3, directionX: 0, 1, stone) ||
                 checkLine(x1: column, y1: row, x2: column + 3, y2: row + 3, directionX: 1, 1, stone) ||
                 checkLine(x1: column, y1: row, x2: column + 3, y2: row - 3, directionX: 1, -1, stone)) {
                return stone
            }
        }
      }
      
      // Überprüfe, ob das Brett voll ist
      for column in 0..<size.columns {
        if board[column][0] == 0 {
          // Es gibt noch mindestens eine freie Stelle, also ist das Spiel noch nicht beendet
          return 0
        }
      }
      
      // Das Brett ist voll, also ist das Spiel unentschieden
      return -1
    }
    
    // Überprüft, ob es auf dem Brett eine Gewinnkombination von Steinen gibt, die von (x1, y1) nach (x2, y2) verläuft.
    // directionX und directionY geben die Richtung der Gewinnkombination an (z.B. (1, 0) für horizontal).
    // stone ist der zu suchende Stein (1 oder 2).
    func checkLine(x1: Int, y1: Int, x2: Int, y2: Int, directionX: Int, _ directionY: Int, _ stone: Int) -> Bool {
      for i in 0...3 {
        let x = x1 + i * directionX
        let y = y1 + i * directionY
        
        // Überprüfe, ob der Stein außerhalb des Bretts liegt
        if x < 0 || x >= size.columns || y < 0 || y >= size.rows {
          return false
        }
        
        // Überprüfe, ob der Stein nicht dem gesuchten entspricht
        if board[x][y] != stone {
          return false
        }
      }
      
      return true
    }
  }
