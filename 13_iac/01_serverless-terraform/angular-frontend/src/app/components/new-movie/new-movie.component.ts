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
    // console.log('Save button clicked:', { title, description, cover });
    const movie = new Movie(title, description, cover);
    const payload = {
      body: JSON.stringify(movie)
    };

    this.moviesApiService.insert(payload).subscribe(
      (res) => {
        // console.log('Movie saved successfully:', res);
        this.showMsg = true;
      },
      (err) => {
        // console.error('Error saving movie:', err);
        this.showMsg = false;
      }
    );
  }

}

