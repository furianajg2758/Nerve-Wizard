# db/seeds.rb

NerveReference.destroy_all

###
# UPPER BODY
###

NerveReference.create!(
  name: "axillary nerve",
  affected_areas: ["shoulder"],
  paresthesia: ["anterior shoulder", "posterior shoulder", "lateral shoulder"],
  sensory: ["anterior shoulder", "posterior shoulder", "lateral shoulder"],
  weakness: ["shoulder abductors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "C5 nerve root",
  affected_areas: ["shoulder", "upper arm", "elbow", "forearm"],
  paresthesia: [],
  sensory: ["anterior shoulder", "posterior shoulder", "lateral shoulder", "anterior elbow", "anterior upper arm", "anterior forearm"],
  weakness: ["shoulder abductors", "shoulder lateral rotators"],
  reflexes: ["biceps brachii", "brachioradialis"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "C6 nerve root",
  affected_areas: ["upper arm", "elbow", "forearm", "wrist", "hand"],
  paresthesia: ["thumb", "index finger"],
  sensory: ["anterior upper arm", "medial elbow", "lateral forearm", "lateral wrist", "radial hand", "thumb", "index finger"],
  weakness: ["elbow flexors", "forearm supinators", "wrist extensors"],
  reflexes: ["biceps brachii", "brachioradialis"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "C7 nerve root",
  affected_areas: ["upper arm", "elbow", "forearm", "wrist", "hand"],
  paresthesia: ["index finger", "middle finger", "ring finger"],
  sensory: ["posterior upper arm", "lateral upper arm", "posterior elbow", "lateral elbow", "lateral forearm", "anterior wrist", "radial hand", "index finger", "middle finger", "ring finger"],
  weakness: ["elbow extensors", "wrist flexors"],
  reflexes: ["triceps"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "C8 nerve root",
  affected_areas: ["upper arm", "elbow", "forearm", "wrist", "hand"],
  paresthesia: ["little finger"],
  sensory: ["medial upper arm", "medial elbow", "medial forearm", "medial wrist", "medial hand", "middle finger", "ring finger", "little finger"],
  weakness: ["wrist ulnar deviators", "thumb extensors", "thumb adductors"],
  reflexes: ["triceps"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "lateral antebrachial cutaneous nerve",
  affected_areas: ["elbow", "forearm", "wrist"],
  paresthesia: ["lateral elbow", "anterior forearm", "lateral forearm", "lateral wrist"],
  sensory: ["lateral elbow", "anterior forearm", "lateral forearm", "lateral wrist"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "lower lateral brachial cutaneous nerve",
  affected_areas: ["upper arm", "elbow"],
  paresthesia: ["lateral upper arm", "lateral elbow"],
  sensory: ["lateral upper arm", "lateral elbow"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "medial antebrachial cutaneous nerve",
  affected_areas: ["elbow", "forearm"],
  paresthesia: ["medial elbow", "anterior forearm", "medial forearm"],
  sensory: ["medial elbow", "anterior forearm", "medial forearm"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "medial brachial cutaneous nerve",
  affected_areas: ["shoulder", "upper arm", "elbow", "forearm"],
  paresthesia: ["anterior shoulder", "medial upper arm", "medial elbow", "medial forearm"],
  sensory: ["anterior shoulder", "medial upper arm", "medial elbow", "medial forearm"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "median nerve",
  affected_areas: ["hand"],
  paresthesia: ["radial hand", "thumb", "index finger", "middle finger"],
  sensory: ["radial hand", "thumb", "index finger", "middle finger"],
  weakness: ["forearm pronators", "wrist flexors", "wrist radial deviators", "thumb abductors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "musculocutaneous nerve",
  affected_areas: ["forearm"],
  paresthesia: ["lateral forearm"],
  sensory: ["lateral forearm"],
  weakness: ["elbow flexors"],
  reflexes: ["biceps brachii"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "posterior antebrachial cutaneous nerve",
  affected_areas: ["elbow", "forearm", "wrist"],
  paresthesia: ["posterior elbow", "posterior forearm", "posterior wrist"],
  sensory: ["posterior elbow", "posterior forearm", "posterior wrist"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "posterior brachial cutaneous nerve",
  affected_areas: ["upper arm"],
  paresthesia: ["posterior upper arm"],
  sensory: ["posterior upper arm"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "radial nerve",
  affected_areas: ["hand"],
  paresthesia: ["dorsum of hand", "thumb", "index finger", "middle finger"],
  sensory: ["dorsum of hand", "thumb", "index finger", "middle finger"],
  weakness: ["elbow extensors", "forearm supinators", "wrist extensors", "thumb abductors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "T1 nerve root",
  affected_areas: ["elbow", "forearm", "wrist", "hand"],
  paresthesia: [],
  sensory: ["medial elbow", "medial forearm", "medial wrist", "medial hand"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "T2 nerve root",
  affected_areas: ["pectoral area", "midscapular area", "upper arm", "elbow"],
  paresthesia: [],
  sensory: ["pectoral area", "midscapular area", "medial upper arm", "medial elbow"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "ulnar nerve",
  affected_areas: ["wrist", "hand"],
  paresthesia: ["medial wrist", "medial hand", "ring finger", "little finger"],
  sensory: ["medial wrist", "medial hand", "ring finger", "little finger"],
  weakness: ["wrist flexors", "wrist ulnar deviators", "thumb adductors", "finger abductors", "finger adductors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "upper lateral brachial cutaneous nerve",
  affected_areas: ["lateral shoulder"],
  paresthesia: ["anterior shoulder", "posterior shoulder", "lateral shoulder"],
  sensory: ["anterior shoulder", "posterior shoulder", "lateral shoulder"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

###
# LOWER LIMB
###

NerveReference.create!(
  name: "common fibular nerve",
  affected_areas: ["lower leg", "ankle", "foot"],
  paresthesia: ["lateral lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"],
  sensory: ["lateral lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"],
  weakness: ["ankle dorsiflexors", "ankle everters"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "deep fibular nerve",
  affected_areas: ["foot"],
  paresthesia: ["webbing between toes one and two"],
  sensory: ["webbing between toes one and two"],
  weakness: ["ankle dorsiflexors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "femoral nerve",
  affected_areas: ["thigh", "knee", "lower leg"],
  paresthesia: ["anterior thigh", "anterior knee", "anterior lower leg"],
  sensory: ["anterior thigh", "anterior knee", "anterior lower leg"],
  weakness: ["hip flexors", "knee extensors"],
  reflexes: ["patellar"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "intermediate cutaneous nerve of the thigh",
  affected_areas: ["thigh", "knee"],
  paresthesia: ["anterior thigh", "anterior knee"],
  sensory: ["anterior thigh", "anterior knee"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "L2 nerve root",
  affected_areas: ["back", "thigh"],
  paresthesia: ["anterior thigh"],
  sensory: ["back", "anterior thigh"],
  weakness: ["hip flexors", "hip adductors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "L3 nerve root",
  affected_areas: ["back", "buttock", "thigh", "knee", "lower leg"],
  paresthesia: ["medial knee", "anterior lower leg"],
  sensory: ["back", "buttock", "anterior thigh", "anterior knee", "medial lower leg"],
  weakness: ["hip flexors", "knee extensors"],
  reflexes: ["patellar"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "L4 nerve root",
  affected_areas: ["buttock", "thigh", "knee", "lower leg", "ankle", "foot"],
  paresthesia: ["medial lower leg", "medial ankle"],
  sensory: ["buttock", "lateral thigh", "medial lower leg", "medial ankle", "dorsum of foot", "big toe"],
  weakness: ["ankle dorsiflexors", "big toe extensors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "L5 nerve root",
  affected_areas: ["buttock", "thigh", "knee", "lower leg", "ankle", "foot"],
  paresthesia: ["lateral lower leg", "lateral ankle", "lateral foot", "big toe", "second toe", "third toe"],
  sensory: ["buttock", "posterior thigh", "lateral thigh", "lateral knee", "lateral lower leg", "dorsum of foot", "medial sole of foot", "big toe", "second toe", "third toe"],
  weakness: ["hip abductors", "ankle dorsiflexors", "ankle everters", "big toe extensors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "lateral cutaneous nerve of the calf",
  affected_areas: ["knee", "lower leg"],
  paresthesia: ["lateral knee", "lateral lower leg"],
  sensory: ["lateral knee", "lateral lower leg"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "lateral cutaneous nerve of the thigh",
  affected_areas: ["thigh"],
  paresthesia: ["lateral thigh"],
  sensory: ["lateral thigh"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "lateral plantar nerve",
  affected_areas: ["foot"],
  paresthesia: ["lateral sole of foot"],
  sensory: ["lateral sole of foot"],
  weakness: ["intrinsic foot muscles"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "medial cutaneous nerve of the thigh",
  affected_areas: ["thigh"],
  paresthesia: ["distal medial thigh"],
  sensory: ["distal medial thigh"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)


NerveReference.create!(
  name: "medial plantar nerve",
  affected_areas: ["foot"],
  paresthesia: ["medial sole of foot"],
  sensory: ["medial sole of foot"],
  weakness: ["intrinsic foot muscles"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "obturator nerve",
  affected_areas: ["thigh"],
  paresthesia: ["proximal medial thigh"],
  sensory: ["proximal medial thigh"],
  weakness: ["hip adductors"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "posterior cutaneous nerve of the thigh",
  affected_areas: ["thigh", "knee", "lower leg"],
  paresthesia: ["posterior thigh", "posterior knee", "posterior lower leg"],
  sensory: ["posterior thigh", "posterior knee", "posterior lower leg"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "S1 nerve root",
  affected_areas: ["buttock", "thigh", "knee", "lower leg", "ankle", "foot"],
  paresthesia: ["lateral lower leg", "lateral ankle", "lateral foot", "lateral sole of foot", "medial sole of foot", "fourth toe", "fifth toe"],
  sensory: ["buttock", "posterior thigh", "posterior knee", "posterior lower leg", "posterior ankle"],
  weakness: ["hip extensors", "knee flexors", "ankle plantarflexors", "ankle everters"],
  reflexes: ["Achilles"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "S2 nerve root",
  affected_areas: ["buttock", "thigh", "knee", "lower leg", "ankle", "foot"],
  paresthesia: ["lateral knee", "lateral lower leg", "lateral ankle", "heel"],
  sensory: ["buttock", "posterior thigh", "posterior knee", "posterior lower leg", "posterior ankle"],
  weakness: ["knee flexors", "ankle plantarflexors"],
  reflexes: ["Achilles"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "S3 nerve root",
  affected_areas: ["groin", "thigh"],
  paresthesia: [],
  sensory: ["groin", "distal medial thigh", "proximal medial thigh"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "saphenous nerve",
  affected_areas: ["knee", "lower leg", "ankle", "foot"],
  paresthesia: ["medial knee", "medial lower leg", "medial ankle", "medial arch of foot"],
  sensory: ["medial knee", "medial lower leg", "medial ankle", "medial arch of foot"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "sciatic nerve",
  affected_areas: ["lower leg", "ankle", "foot"],
  paresthesia: ["posterior lower leg", "lateral lower leg", "medial lower leg", "dorsum of foot", "lateral sole of foot", "medial sole of foot"],
  sensory: ["posterior lower leg", "lateral lower leg", "medial lower leg", "dorsum of foot", "lateral sole of foot", "medial sole of foot"],
  weakness: ["knee flexors", "ankle dorsiflexors", "ankle plantarflexors", "ankle everters", "ankle inverters"],
  reflexes: ["Achilles"],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "superficial fibular nerve",
  affected_areas: ["lower leg", "ankle", "foot"],
  paresthesia: ["lateral lower leg", "lateral ankle", "dorsum of foot"],
  sensory: ["lateral lower leg", "lateral ankle", "dorsum of foot"],
  weakness: ["ankle everters"],
  reflexes: [],
  nerve_type: "mixed"
)

NerveReference.create!(
  name: "sural nerve",
  affected_areas: ["lower leg", "ankle", "foot"],
  paresthesia: ["lateral lower leg", "lateral ankle", "lateral foot", "fifth toe"],
  sensory: ["lateral lower leg", "lateral ankle", "lateral foot", "fifth toe"],
  weakness: [],
  reflexes: [],
  nerve_type: "sensory"
)

NerveReference.create!(
  name: "tibial nerve",
  affected_areas: ["lower leg", "foot"],
  paresthesia: ["heel"],
  sensory: ["heel"],
  weakness: ["ankle plantarflexors"],
  reflexes: [],
  nerve_type: "mixed"
)

puts "Successfully seeded #{NerveReference.count} nerve references!"
