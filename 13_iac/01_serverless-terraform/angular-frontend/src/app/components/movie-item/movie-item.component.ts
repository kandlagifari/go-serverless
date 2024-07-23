import { Component, OnInit, Input } from '@angular/core';
import { Movie } from '../../models/movie';

@Component({
  selector: 'movie-item',
  standalone: true,
  imports: [],
  templateUrl: './movie-item.component.html',
  styleUrl: './movie-item.component.css'
})
export class MovieItemComponent implements OnInit {

  @Input()
  public movie!: Movie;

  constructor() { }

  ngOnInit() {
  }

}
