import { FormEvent, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "react-query";

async function getTopTen() {
    return await fetch("/api/top-ten").then((res) => res.json());
}

async function createTweet(tweet: Record<string, any>) {
    console.log("tweet", tweet);
    return await fetch("/api/create", {
        method: "POST",
        body: JSON.stringify(tweet),
    }).then((res) => res.json());
}

export default function Home() {
    const { data, isLoading, error } = useQuery("top-ten", getTopTen);
    const queryClient = useQueryClient();
    const mutation = useMutation(createTweet);
    const [hashtag, setHashtag] = useState("");

    if (isLoading) {
        return <p>loading top ten</p>;
    }

    if (error) {
        return <p>Error: {JSON.stringify(error)}</p>;
    }

    function handleSubmit(event: FormEvent<HTMLFormElement>): void {
        event.preventDefault();
        mutation.mutate({ hashtag }, {
            onSuccess() {
                queryClient.invalidateQueries("top-ten");
            },
        });
    }

    return (
        <>
            <main style={{ display: "flex" }}>
                <div>
                    {" "}
                    <h1>Top ten</h1>
                    <pre> {JSON.stringify(data, null, 2)}</pre>
                </div>
                <div>
                    <h1>Create data</h1>
                    <form onSubmit={handleSubmit}>
                        <label>
                            Hashtag:
                            <input name="name" onChange={(e) => setHashtag(e.target.value)} />
                        </label>
                        <br />
                        <button type="submit">Submit</button>
                    </form>
                    {mutation.data && <pre>{JSON.stringify(mutation.data, null, 2)}</pre>}
                </div>
            </main>
        </>
    );
}
