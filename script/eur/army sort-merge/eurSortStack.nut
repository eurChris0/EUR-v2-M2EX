class eurSortStack {
    function eurSortStack(faction) {
        ::EUR.logHelper("eurSortStack")
        for (local j = 0; j < faction.armyCount; j++) {
            local stack = faction.army(j)
            if (stack == null) continue
            if (stack.inSettlement() || stack.inFort()) continue
            stack.sortUnits(::EUR.sort_order.a + 1, ::EUR.sort_order.b + 1, ::EUR.sort_order.c + 1)
        }
        ::EUR.logHelper("eurSortStack end")
    }

    function eurSortOnSelected(selectedChar) {
        ::EUR.logHelper("eurSortOnSelected")
        if (selectedChar.character.army) {
            selectedChar.character.army.sortUnits(::EUR.sort_order.a + 1, ::EUR.sort_order.b + 1, ::EUR.sort_order.c + 1)
        }
        ::EUR.logHelper("eurSortOnSelected end")
    }
}

::EUR.eurSortStack <- eurSortStack()
