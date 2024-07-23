import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment.prod';
import { Movie } from '../models/movie';

@Injectable({
  providedIn: 'root'
})
export class MoviesApiService {

  constructor(private http: HttpClient) { }

  findAll(): Observable<Movie[]> {
    return this.http
      .get<Movie[]>(environment.api)
      .pipe(map(res => res));
  }

  insert(payload: any): Observable<any> {
    return this.http
      .post<any>(environment.api, payload)
      .pipe(map(res => res));
  }

}
