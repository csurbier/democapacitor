import { WebPlugin } from '@capacitor/core';
import { DemoCapacitorPlugin } from './definitions';

export class DemoCapacitorWeb extends WebPlugin implements DemoCapacitorPlugin {
  constructor() {
    super({
      name: 'DemoCapacitor',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }
}

const DemoCapacitor = new DemoCapacitorWeb();

export { DemoCapacitor };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(DemoCapacitor);
