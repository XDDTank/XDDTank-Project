// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ILayerFactory

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;

    public interface ILayerFactory 
    {

        function createLayer(_arg_1:ItemTemplateInfo, _arg_2:Boolean, _arg_3:String="", _arg_4:String="show", _arg_5:Boolean=false, _arg_6:int=1, _arg_7:String=null, _arg_8:String=""):ILayer;

    }
}//package ddt.view.character

