import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { ChartModule } from 'ng2-charts'; // <--- Add this

// Import your new components here
import { DashboardComponent } from './dashboard/dashboard.component';
import { SidebarComponent } from './sidebar/sidebar.component';
import { HeaderComponent } from './header/header.component';
import { KpiCardComponent } from './kpi-card/kpi-card.component';

@NgModule({
  declarations: [
    AppComponent,
    DashboardComponent,
    SidebarComponent,
    HeaderComponent,
    KpiCardComponent, // Declare any new components
  ],
  imports: [
    BrowserModule,
    ChartModule, // <--- Add ChartModule here
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
