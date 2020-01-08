import { WebPlugin } from '@capacitor/core';
import { DemoCapacitorPlugin } from './definitions';
export declare class DemoCapacitorWeb extends WebPlugin implements DemoCapacitorPlugin {
    constructor();
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}
declare const DemoCapacitor: DemoCapacitorWeb;
export { DemoCapacitor };
