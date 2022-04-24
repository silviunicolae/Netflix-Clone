//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Silviu Nicolae on 24.04.2022.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    enum DataBaseError: Error {
        case failedToSave
        case failedToFetch
        case failedToDelete
    }
    static let shared = DataPersistenceManager()
    
    func downloadMovie(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        
        item.id = Int64(model.id)
        item.title = model.title
        item.original_title = model.original_title
        item.media_type = model.media_type
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSave))
        }
    }
    
    func fetchMovieFromDB(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(DataBaseError.failedToFetch))
        }
    }
    
    func deleteMovie(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
}
