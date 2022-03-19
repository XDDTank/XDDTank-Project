// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.walkcharacter.WalkCharaterLayer

package ddt.view.walkcharacter
{
    import ddt.view.character.BaseLayer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;

    public class WalkCharaterLayer extends BaseLayer 
    {

        private var _direction:int;
        private var _sex:Boolean;
        private var _clothPath:String;

        public function WalkCharaterLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:int=1, _arg_4:Boolean=true, _arg_5:String="")
        {
            this._direction = _arg_3;
            this._sex = _arg_4;
            this._clothPath = _arg_5;
            super(_arg_1, _arg_2);
        }

        override protected function getUrl(_arg_1:int):String
        {
            return (PathManager.solveSceneCharacterLoaderPath(_info.CategoryID, _info.Pic, this._sex, (_info.NeedSex == 1), String(_arg_1), this._direction, this._clothPath));
        }


    }
}//package ddt.view.walkcharacter

