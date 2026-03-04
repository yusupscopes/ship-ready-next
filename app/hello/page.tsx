import { ErrorBoundary } from "react-error-boundary";
import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { getQueryClient, trpc } from "@/trpc/server";
import { Suspense } from "react";
import { auth } from "@/lib/auth";
import { headers } from "next/headers";
import { redirect } from "next/navigation";
import { ClientGreeting } from "./_components/client-greeting";

const Page = async () => {
  // const session = await auth.api.getSession({
  //   headers: await headers(),
  // });

  // if (!session) {
  //   redirect("/sign-in");
  // }

  const queryClient = getQueryClient();
  await queryClient.prefetchQuery(
    trpc.hello.sayHello.queryOptions({ text: "world" }),
  );

  return (
    <>
      <HydrationBoundary state={dehydrate(queryClient)}>
        <Suspense fallback={<div>Loading Greeting...</div>}>
          <ErrorBoundary fallback={<div>Something went wrong</div>}>
            <ClientGreeting />
          </ErrorBoundary>
        </Suspense>
      </HydrationBoundary>
    </>
  );
};

export default Page;
