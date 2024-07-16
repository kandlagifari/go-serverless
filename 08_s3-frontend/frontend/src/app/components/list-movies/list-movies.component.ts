import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Movie } from '../../models/movie';
import { MovieItemComponent } from '../movie-item/movie-item.component';
import { MoviesApiService } from '../../services/movies-api.service';

@Component({
  selector: 'list-movies',
  standalone: true,
  imports: [CommonModule, MovieItemComponent],
  templateUrl: './list-movies.component.html',
  styleUrl: './list-movies.component.css'
})
export class ListMoviesComponent implements OnInit {

  public movies: Movie[];

  constructor(private moviesApiService: MoviesApiService) {
    this.movies = []

    this.moviesApiService.findAll().subscribe(res => {
      res.forEach(movie => {
        this.movies.push(new Movie(movie.name, movie.description, movie.cover))
      })
    })
  }

  ngOnInit() {
  }

}
