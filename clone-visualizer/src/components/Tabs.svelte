<script>
    import FileExplorer from "./FileExplorer.svelte";
    import About from "./About.svelte";
    import SourceViewer from "./SourceViewer.svelte";
    import TreeMap from "./TreeMap/TreeMap.svelte";

    const ab = "ab";
    const fe = "fe";
    const tm = "tm";
    const sv = "sv";
    const tabs = {
        ab: About,
        fe: FileExplorer,
        tm: TreeMap,
        sv: SourceViewer,
    }

    let current = ab;
    let viewportComponent = tabs[ab];

    const clickHandler = el => {
        // change is active
        current = el;

        // change contents
        viewportComponent = tabs[el];
    }
</script>


<div class="tabs is-centered">
    <ul>
        <li on:click={() => clickHandler(ab)} class="{current === ab ? 'is-active' : ''}"><a>About</a></li>
        <li on:click={() => clickHandler(fe)} class="{current === fe ? 'is-active' : ''}"><a>File Explorer</a></li>
        <li on:click={() => clickHandler(tm)} class="{current === tm ? 'is-active' : ''}"><a>Tree Map</a></li>
<!--        <li on:click={() => clickHandler(sv)} class="{current === sv ? 'is-active' : ''}"><a>JSON</a></li>-->
    </ul>
</div>

<div class="tab-content p-4">
    <svelte:component this={viewportComponent}></svelte:component>
</div>

<style>
    .tab-content {
        max-height: 100%;
    }
</style>