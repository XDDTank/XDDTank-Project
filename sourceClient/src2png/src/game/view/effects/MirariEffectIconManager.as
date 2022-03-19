// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.MirariEffectIconManager

package game.view.effects
{
    import road7th.data.DictionaryData;
    import game.objects.MirariType;

    public class MirariEffectIconManager 
    {

        private static var _instance:MirariEffectIconManager;

        private var _effecticons:DictionaryData;
        private var _isSetup:Boolean;

        public function MirariEffectIconManager(_arg_1:SingletonEnforce)
        {
            this.initialize();
        }

        public static function getInstance():MirariEffectIconManager
        {
            if (_instance == null)
            {
                _instance = new MirariEffectIconManager(new SingletonEnforce());
            };
            return (_instance);
        }


        private function initialize():void
        {
            this._effecticons = new DictionaryData();
            this._isSetup = false;
        }

        private function release():void
        {
            if (this._effecticons)
            {
                this._effecticons.clear();
            };
            this._effecticons = null;
        }

        public function get isSetup():Boolean
        {
            return (this._isSetup);
        }

        public function setup():void
        {
            if (this._isSetup == false)
            {
                this._isSetup = true;
                this._effecticons.add(MirariType.Tired, TiredEffectIcon);
                this._effecticons.add(MirariType.Firing, FiringEffectIcon);
                this._effecticons.add(MirariType.LockAngl, LockAngleEffectIcon);
                this._effecticons.add(MirariType.Weakness, WeaknessEffectIcon);
                this._effecticons.add(MirariType.NoHole, NoHoleEffectIcon);
                this._effecticons.add(MirariType.Defend, DefendEffectIcon);
                this._effecticons.add(MirariType.Targeting, TargetingEffectIcon);
                this._effecticons.add(MirariType.DisenableFly, DisenableFlyEffectIcon);
                this._effecticons.add(MirariType.LimitMaxForce, LimitMaxForceEffectIcon);
                this._effecticons.add(MirariType.ReduceStrength, ReduceStrengthEffect);
                this._effecticons.add(MirariType.ResolveHurt, ResolveHurtEffectIcon);
                this._effecticons.add(MirariType.ReversePlayer, RevertEffectIcon);
                this._effecticons.add(MirariType.Defense, DefenseEffectIcon);
                this._effecticons.add(MirariType.Attack, AttackEffectIcon);
            };
        }

        public function unsetup():void
        {
            if (this._isSetup)
            {
                this.release();
                this._isSetup = false;
            };
        }

        public function createEffectIcon(_arg_1:int):BaseMirariEffectIcon
        {
            if ((!(this._isSetup)))
            {
                this.setup();
            };
            var _local_2:Class = (this._effecticons[_arg_1] as Class);
            if (_local_2 == null)
            {
                return (null);
            };
            return (new (_local_2)() as BaseMirariEffectIcon);
        }


    }
}//package game.view.effects

class SingletonEnforce 
{


}


