import {Interface as Protosite} from '@protosite/vue-protosite/vue-protosite/interface'

// You can configure the Protosite interface here and override functionality of
// any of the base components if you'd like. The Protosite interface exposes
// most of itself for the express purpose of being extensible and flexible.

// Finally, we expose this so Protosite core can instantiate it and give us our
// CMA interface.
window.Protosite = Protosite
