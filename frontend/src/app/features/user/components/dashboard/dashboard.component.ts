import { Component } from '@angular/core';
import { BaseChartDirective } from 'ng2-charts';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [BaseChartDirective], // <-- REQUIRED
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
})
export class DashboardComponent {
  pieChartData = {
    labels: ['Active', 'Inactive'],
    datasets: [{ data: [70, 30] }],
  };

  pieChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
  };
}
