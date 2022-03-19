// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.NotifyMachine

package cmodule.decry
{
    import cmodule.decry.Machine;
    import cmodule.decry.log;

    internal class NotifyMachine extends Machine 
    {

        private var proc:Function;

        public function NotifyMachine(_arg_1:Function)
        {
            this.proc = _arg_1;
            public::mstate.push(0);
            public::mstate.push(public::mstate.ebp);
            public::mstate.ebp = public::mstate.esp;
        }

        override public function work():void
        {
            var noClean:Boolean;
            try
            {
                noClean = ((this.proc()) ? true : false);
            }
            catch(e)
            {
                log(1, ("NotifyMachine: " + e));
            };
            if ((!(noClean)))
            {
                public::mstate.gworker = caller;
                public::mstate.ebp = public::mstate.pop();
                public::mstate.pop();
            };
        }


    }
}//package cmodule.decry

