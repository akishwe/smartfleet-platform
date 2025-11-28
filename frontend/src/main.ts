import { bootstrapApplication } from '@angular/platform-browser';
import { provideCharts } from 'ng2-charts';
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, {
  providers: [provideCharts()],
});
