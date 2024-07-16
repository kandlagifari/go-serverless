import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Movie } from '../../models/movie';
import { MovieItemComponent } from '../movie-item/movie-item.component';

@Component({
  selector: 'list-movies',
  standalone: true,
  imports: [CommonModule, MovieItemComponent],
  templateUrl: './list-movies.component.html',
  styleUrl: './list-movies.component.css'
})
export class ListMoviesComponent implements OnInit {

  public movies: Movie[];

  constructor() {
    this.movies = [
      new Movie("Sousou no Frieren", "Some description",
        "https://cdn.myanimelist.net/images/anime/1015/138006.jpg"),
      new Movie("Steins;Gate", "Some description",
        "https://cdn.myanimelist.net/images/anime/1935/127974.jpg"),
      new Movie("Koe no Katachi", "Some description",
        "https://cdn.myanimelist.net/images/anime/1122/96435.jpg")
    ];
  }

  ngOnInit() {
  }
}
