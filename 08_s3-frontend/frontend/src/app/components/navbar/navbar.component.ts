import { Component, OnInit, Input } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { CommonModule } from '@angular/common';
import { NewMovieComponent } from '../new-movie/new-movie.component'

@Component({
  selector: 'movies-navbar',
  standalone: true,
  imports: [NewMovieComponent, CommonModule],
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.css'
})
export class NavbarComponent implements OnInit {
  constructor(private modalService: NgbModal) {}

  ngOnInit() {}

  newMovie(content: any){
    const modalRef = this.modalService.open(content, { size: 'lg' });
    modalRef.result.then((result) => {
      console.log(`Closed with: ${result}`);
    }, (reason) => {
      console.log(`Dismissed: ${reason}`);
    });
  }
}
