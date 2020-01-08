declare module "@capacitor/core" {
  interface PluginRegistry {
    DemoCapacitor: DemoCapacitorPlugin;
  }
}

export interface DemoCapacitorPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
}
