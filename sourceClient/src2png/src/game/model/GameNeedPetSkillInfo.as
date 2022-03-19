// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.GameNeedPetSkillInfo

package game.model
{
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;

    public class GameNeedPetSkillInfo 
    {

        private var _pic:String;
        private var _effect:String;


        public function get pic():String
        {
            return (this._pic);
        }

        public function set pic(_arg_1:String):void
        {
            this._pic = _arg_1;
        }

        public function get effect():String
        {
            return (this._effect);
        }

        public function set effect(_arg_1:String):void
        {
            this._effect = _arg_1;
        }

        public function get effectClassLink():String
        {
            return ("asset.game.skill.effect." + this.effect);
        }

        public function startLoad():void
        {
            if ((!(this.effect)))
            {
                return;
            };
            LoadResourceManager.instance.creatAndStartLoad(PathManager.solvePetSkillEffect(this.effect), BaseLoader.MODULE_LOADER);
        }


    }
}//package game.model

