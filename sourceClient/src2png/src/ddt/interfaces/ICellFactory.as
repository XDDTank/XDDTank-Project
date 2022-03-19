// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.interfaces.ICellFactory

package ddt.interfaces
{
    import ddt.data.goods.ItemTemplateInfo;

    public interface ICellFactory 
    {

        function createBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true):ICell;
        function createPersonalInfoCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true):ICell;

    }
}//package ddt.interfaces

