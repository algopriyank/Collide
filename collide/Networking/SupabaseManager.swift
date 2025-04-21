//
//  SupabaseManager.swift
//  collide
//
//  Created by Priyank Sharma on 20/04/25.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://elxkzdrcyloubqhwiuuu.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVseGt6ZHJjeWxvdWJxaHdpdXV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM5MzI2MDEsImV4cCI6MjA1OTUwODYwMX0.835jbXGwqRA8aSI6LIiczBshfOOYUBRrZNnhHgRmlcM"
        )
    }
}
