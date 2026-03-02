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
            supabaseURL: URL(string: "https://fjyepdpsuhxdtbwjkynw.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqeWVwZHBzdWh4ZHRid2preW53Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4NTI0ODgsImV4cCI6MjA4MDQyODQ4OH0.HwO5JQk4h_RoSni0HVbBo3g525qvpe9zuFCgXllk5nw"
        )
    }
}
