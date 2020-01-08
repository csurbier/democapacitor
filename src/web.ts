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
    console.log('ECHO WEB CS', options);
    return options;
  }

  async showAppleLogin(): Promise<any> {
    console.log('ECHO WEB showAppleLogin');
    return;
  }
}

const DemoCapacitor = new DemoCapacitorWeb();

export { DemoCapacitor };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(DemoCapacitor);
