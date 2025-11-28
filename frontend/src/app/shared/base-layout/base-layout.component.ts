import { Component } from '@angular/core';

import { RouterModule } from '@angular/router'; // For routerLink
import { NgClass } from '@angular/common';

@Component({
  selector: 'app-base-layout',
  standalone: true,
  imports: [RouterModule, NgClass],
  templateUrl: './base-layout.component.html',
  styleUrls: ['./base-layout.component.scss'],
})
export class BaseLayoutComponent {
  userName = 'John Doe';
  currentYear = new Date().getFullYear();
}
