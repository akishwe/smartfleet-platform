import { Routes } from '@angular/router';
import { LoginComponent } from './features/user/components/login/login.component';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },

  // Root should redirect ONCE
  { path: '', redirectTo: 'login', pathMatch: 'full' },

  // Wildcard should redirect to login
  { path: '**', redirectTo: 'login' },
];
