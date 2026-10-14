import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class DashboardService {
  constructor(private readonly prisma: PrismaService) {}
  async getSummary() {
    const activePlayers = await this.prisma.players.count({
      where: {
        status: 'active',
        is_test: false,
      },
    });

    return {
      activePlayers: {
        value: activePlayers,
        comparison: 5,
      },
    };
  }
}
