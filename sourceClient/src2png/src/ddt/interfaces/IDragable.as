// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.interfaces.IDragable

package ddt.interfaces
{
    import bagAndInfo.cell.DragEffect;

    public interface IDragable 
    {

        function getSource():IDragable;
        function dragStop(_arg_1:DragEffect):void;

    }
}//package ddt.interfaces

