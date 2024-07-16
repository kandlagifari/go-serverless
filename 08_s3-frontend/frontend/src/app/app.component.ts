import { BrowserModule } from '@angular/platform-browser';
import { NgModule, Component } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { RouterOutlet } from '@angular/router';

import { NavbarComponent } from './components/navbar/navbar.component';
import { MovieItemComponent } from './components/movie-item/movie-item.component';
import { ListMoviesComponent } from './components/list-movies/list-movies.component';
import { MoviesApiService } from './services/movies-api.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    NavbarComponent,
    MovieItemComponent,
    ListMoviesComponent,
    HttpClientModule
  ],
  providers: [
    MoviesApiService
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})

export class AppComponent {
  title = 'frontend';
}
