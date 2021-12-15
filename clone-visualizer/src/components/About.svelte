<script>
    import Benchmark from "./Benchmark.svelte";
</script>

<div class="columns">
    <div class="column is-three-quarters">
        <p>
            This clone visualizer uses a Rascal backend that detects type 1 and type 2 clones in your Java codebase.
            On the right-side you see how much code duplication is within your code, amongst other benchmarks.
        </p>
        <br/>
        <p>
            On the other tabs (File Explorer and Tree map) you can visually inspect the clones within your codebase.
            The first shows which files contains what clones and second depicts the clones that occur most frequently
            regardless of the file it occurred in.
        </p>
    </div>
    <div class="column">
        <Benchmark/>
    </div>
</div>