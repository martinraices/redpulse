import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service.js';

@Injectable()
export class AppService {
  constructor(private readonly prisma: PrismaService) {}

  getHello(): string {
    return 'Hello World!';
  }

  async getDatabaseCheck(): Promise<{ marketCount: number }> {
    const marketCount = await this.prisma.markets.count();

    return { marketCount };
  }
}
