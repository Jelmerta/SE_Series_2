<script>
    import Benchmark from "./Benchmark.svelte";
</script>

<div class="section content mt-0 pt-0">
    <div class="column is-two-thirds">
        <p>
            This clone visualizer uses a Rascal backend that detects type 1 and type 2 clones in your Java codebase.
            On the right-side you see how much code duplication is within your code, amongst other benchmarks.
        </p>
        <p>
            On the other tabs (File Explorer and Tree map) you can visually inspect the clones within your codebase.
        </p>
        <p class="title is-bold">
            File Explorer
        </p>
        <p>
            The file explorer list all files that contain code clones and are sorted by the files that contain most clones.
            You can click the on the file and a modal will show details per clone within the file:
        </p>
        <ul>
            <li>Total amount of lines</li>
            <li>Line numbers</li>
            <li>Lines</li>
        </ul>
        <p class="title is-bold">
            Tree Map
        </p>
        <p>
            The tree map show the most occurring clone classes. Upon clicking on the clone class, you can see the following details:
        </p>
        <ul>
            <li>Total amount of duplications of the clone class</li>
            <li>Tree size</li>
            <li>A list of the duplications that have been found, with the following details:</li>
            <ul>
                <li>Filepath</li>
                <li>Line numbers</li>
                <li>Code lines</li>
                <li>Amount of lines</li>
            </ul>
        </ul>
    </div>
<!--    <div class="column">-->
<!--        <Benchmark/>-->
<!--    </div>-->
</div>