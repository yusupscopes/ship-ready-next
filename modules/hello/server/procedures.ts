import { z } from "zod";
import { baseProcedure, createTRPCRouter } from "@/trpc/init";
export const helloRouter = createTRPCRouter({
  sayHello: baseProcedure
    .input(
      z.object({
        text: z.string(),
      }),
    )
    .query(async (opts) => {
      await new Promise((resolve) => setTimeout(resolve, 2000));
      return {
        greeting: `hello ${opts.input.text}`,
      };
    }),
});
// export type definition of API
export type HelloRouter = typeof helloRouter;
