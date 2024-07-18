import { Component, OnInit, Input } from '@angular/core';
import { Movie } from '../../models/movie';
import { NavbarComponent } from '../navbar/navbar.component'
import { CommonModule } from '@angular/common';
import { MoviesApiService } from '../../services/movies-api.service';

@Component({
  selector: 'new-movie',
  standalone: true,
  imports: [NavbarComponent, CommonModule],
  templateUrl: './new-movie.component.html',
  styleUrl: './new-movie.component.css'
})
export class NewMovieComponent implements OnInit {
  @Input() dismiss !: Function;

  private movie !: Movie;
  public showMsg: boolean;

  constructor(private moviesApiService: MoviesApiService) {
    this.showMsg = false;
  }

  ngOnInit() {
  }

  save(title: string, description: string, cover: string) {
    this.dismiss();
    this.movie = new Movie(title, description, cover);
    this.moviesApiService.insert(this.movie).subscribe(
      res => {
        this.showMsg = true;
      },
      err => {
        this.showMsg = false;
      }
    );
  }

}

