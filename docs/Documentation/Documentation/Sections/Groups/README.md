<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Groups

Groups are a class that allows you to group objects together. This helps with organization and ordering:

```haxe
import vupx.groups.VpGroup;

var group = new VpGroup();

// Add an object to the group
var sprite = new VpSprite(100, 100);
group.add(sprite);
```

-----------

- [`vupx.groups.VpGroup`](../../../../vupx/groups/VpGroup.hx)