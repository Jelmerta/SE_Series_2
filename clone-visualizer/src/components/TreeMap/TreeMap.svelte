<script>
    import * as Pancake from '@sveltejs/pancake';
    import * as d3 from 'd3-hierarchy';
    import { tweened } from 'svelte/motion';
    import * as eases from 'svelte/easing';
    import { fade } from 'svelte/transition';
    import * as yootils from 'yootils';
    import Treemap from './TreeMapper.svelte';
    import * as clonesData from '../../../data/clones.json';
    import TreeMapModal from "./TreeMapModal.svelte";

    const treemap = d3.treemap();

    let active = false;
    let data;

    let clones = []
    let formattedClones = clonesData.default.map(clone => {
        const newObject = {};

        delete Object.assign(newObject, clone.cloneClass, {["name"]: clone.cloneClass["cloneClassName"] })["cloneClassName"];
        delete Object.assign(newObject, clone.cloneClass, {["amountOfDuplications"]: clone.cloneClass["amountOfDuplications"] })["amountOfDuplications"];
        delete Object.assign(newObject, clone.cloneClass, {["children"]: clone.cloneClass["duplications"] })["duplications"];

        let newChildren = [];

        newObject.children.map(o => {
            let test = o.duplication;
            let newChild = {};
           newChild["name"] = test.filePath;
           newChild["value"] = test.amountOfLines;
           newChild["lines"] = test.lines;
           newChild["code"] = test.code;

           newChildren.push(newChild);
        });

        newObject.children = newChildren;
        delete newObject.cloneClassName;
        delete newObject.treeSize;
        clones.push(newObject);
    });

    let actualClones = {
        "name": "Clones",
        "children": clones
    }

    const hierarchy = d3.hierarchy(actualClones)
        .sum(d => d.amountOfDuplications)
        .sort((a, b) => b.amountOfDuplications - a.amountOfDuplications)

    const root = treemap(hierarchy);

    let selected = root;

    const select = node => {
        while (node.parent && node.parent !== selected) {
            node = node.parent;
            active = !active;
        }

        if (node && node.children) selected = node;

        if (node.depth === 1) {
            data = node.children;
        }
    };

    const breadcrumbs = node => {
        const crumbs = [];
        while (node) {
            crumbs.unshift(node.data.name)
            node = node.parent;
        }

        return crumbs.join('/');
    };

    const extents = tweened(undefined, {
        easing: eases.cubicOut,
        duration: 600
    });

    const is_visible = (a, b) => {
        while (b) {
            if (a.parent === b) return true;
            b = b.parent;
        }

        return false;
    };

    $: $extents = {
        x1: selected.x0,
        x2: selected.x1,
        y1: selected.y1,
        y2: selected.y0
    };
</script>

<button class="breadcrumbs" disabled="{!selected.parent}" on:click="{() => selected = selected.parent}">
    {breadcrumbs(selected)}
</button>

<div class="chart">
    <Pancake.Chart x1={$extents.x1} x2={$extents.x2} y1={$extents.y1} y2={$extents.y2}>
        <Treemap {root} let:node>
            {#if is_visible(node, selected)}
                <div
                        transition:fade={{duration:400}}
                        class="node text-wrap"
                        class:leaf={!node.children}
                        on:click="{() => select(node)}"
                >
                    <div class="treemap-contents">
                        <strong class="wrap-text">{node.data.name}</strong>
                        <span>{yootils.commas(node.value)}</span>
                    </div>
                </div>
            {/if}
        </Treemap>
    </Pancake.Chart>
</div>

<TreeMapModal {active} {data}/>

<style>
    .breadcrumbs {
        width: 100%;
        padding: 0.3rem 0.4rem;
        background-color: transparent;
        font-family: inherit;
        font-size: inherit;
        text-align: left;
        border: none;
        cursor: pointer;
        outline: none;
    }

    .breadcrumbs:disabled {
        cursor: default;
    }

    .chart {
        width: calc(100% + 2px);
        height: 400px;
        padding: 0;
        margin: 0 -1px 36px -1px;
        overflow: hidden;
    }

    .node {
        position: absolute;
        width: 100%;
        height: 100%;
        background-color: white;
        overflow: hidden;
        pointer-events: all;
    }

    .node:not(.leaf) {
        cursor: pointer;
    }

    .treemap-contents {
        width: 100%;
        height: 100%;
        padding: 0.3rem 0.4rem;
        border: 1px solid white;
        background-color: hsl(240, 8%, 70%);
        color: white;
        border-radius: 4px;
        box-sizing: border-box;
    }

    .node:not(.leaf) .treemap-contents {
        background-color: hsl(240, 8%, 44%);
    }

    strong, span {
        display: block;
        font-size: 12px;
        /*white-space: nowrap;*/
        line-height: 1;
        color: white !important;
    }

    .wrap-text{
        display: block;/* or inline-block */
        text-overflow: ellipsis;
        word-wrap: break-word;
        overflow: hidden;
        max-height: 3.6em;
        line-height: 1.8em;
    }
</style>