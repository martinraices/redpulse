import { Controller, Get } from '@nestjs/common';
import { DashboardService } from './dashboard.service.js';

//All routes in this class start with /dashboard
@Controller('dashboard')
export class DashboardController {
  // NestJS injects an instance of DashboardService here.
  // "private readonly" means this service is available inside this class
  // and should not be reassigned.
  constructor(private readonly dashboardService: DashboardService) {}

  // This creates a GET endpoint:
  // GET /dashboard/summary
  @Get('summary')
  getSummary() {
    // Instead of calculating the data inside the controller,
    // we ask the service to do the work.
    return this.dashboardService.getSummary();
  }
}
