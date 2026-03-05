import { createTRPCRouter } from "../init";
import { helloRouter } from "@/modules/hello/server/procedures";

export const appRouter = createTRPCRouter({
  hello: helloRouter,
});

// export type definition of API
export type AppRouter = typeof appRouter;
