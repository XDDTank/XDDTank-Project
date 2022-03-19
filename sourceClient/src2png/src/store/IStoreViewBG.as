// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.IStoreViewBG

package store
{
    import com.pickgliss.ui.core.Disposeable;
    import bagAndInfo.cell.BagCell;
    import flash.utils.Dictionary;

    public interface IStoreViewBG extends Disposeable 
    {

        function setCell(_arg_1:BagCell):void;
        function refreshData(_arg_1:Dictionary):void;
        function updateData():void;
        function hide():void;
        function show():void;
        function openHelp():void;

    }
}//package store

