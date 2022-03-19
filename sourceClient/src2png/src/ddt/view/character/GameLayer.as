// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.GameLayer

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;

    public class GameLayer extends BaseLayer 
    {

        private var _state:String = "";
        private var _sex:Boolean;

        public function GameLayer(_arg_1:ItemTemplateInfo, _arg_2:String, _arg_3:Boolean=false, _arg_4:int=1, _arg_5:String=null, _arg_6:String="")
        {
            this._state = _arg_6;
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        override protected function getUrl(_arg_1:int):String
        {
            return (PathManager.solveGoodsPath(_info, _pic, (_info.NeedSex == 1), BaseLayer.GAME, _hairType, String(_arg_1), info.Level, _gunBack, int(_info.Property1), this._state));
        }


    }
}//package ddt.view.character

